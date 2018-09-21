Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUO5V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 10:57:21 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, robh+dt@kernel.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 0/4] Enable ath10k wcn3990 wifi driver support on sdm845
Date: Fri, 21 Sep 2018 14:39:03 +0530
Message-Id: <20180921090907.25937-1-govinds@codeaurora.org> (sfid-20180921_110930_113598_1DC62700)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series enables ath10k wifi driver support for WCN3990 target
on sdm845 SOC. This series also updates the missing dt binding documentation
and adds optional iommu property.

sdm845 dtsi changes in this series are based on top of
https://patchwork.kernel.org/cover/10573121/ change.

Govind Singh (4):
  dt: bindings: add missing dt properties for WCN3990 wifi node
  dts: arm64/sdm845: Add WCN3990 WLAN module device node
  dt: bindings: add bindings for wifi iommu node
  dts: arm64/sdm845: Enable iommu for WCN3990 wifi module device node

 .../bindings/net/wireless/qcom,ath10k.txt     | 27 ++++++++++++++-----
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts       |  7 +++++
 arch/arm64/boot/dts/qcom/sdm845.dtsi          | 26 ++++++++++++++++++
 3 files changed, 53 insertions(+), 7 deletions(-)

-- 
2.17.0
