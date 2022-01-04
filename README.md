# IPGA-for-MTSP
## Background and Reference
This project developed a genetic algorithm package to solve the multi-traveling salesman problem based on the IPGA proposed by Zhou et al. (2018).

- Zhou, H., Song, M., & Pedrycz, W. (2018). A comparative study of improved GA and PSO in solving multiple traveling salesmen problem. *Applied Soft Computing*, 64, 564-580.

## Methodology
### 染色体编码
<div align=center>
<img src="https://files.catbox.moe/pt7jji.jpg" width="80%"/>
</div>

### IPGA
<div align=center>
<img src="https://files.catbox.moe/bmro7d.jpg" width="80%"/>
</div>

### 交叉算子
- FlipInsert
- SwapInsert
- LSliInsert
- RSliInsert
### 变异算子

## Example
### Dateset
使用`data_Generate.m`在设定的`rangeX`和`rangeY`范围内生成`nCity`个点
```
rangeX = [-85.085, -84.607];
rangeY = [ 43.467,  43.815];
CityCoor(:, 1) = unifrnd(rangeX(1), rangeX(2), nCity, 1);
CityCoor(:, 2) = unifrnd(rangeY(1), rangeY(2), nCity, 1);
```
### Results
<div align=center>
<img src="https://files.catbox.moe/h5zmk4.svg" width="80%"/>
</div>
