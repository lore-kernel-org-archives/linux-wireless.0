Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373B5C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 03:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 114A520855
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 03:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfARDdE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 22:33:04 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726858AbfARDdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 22:33:03 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 741ABC4626CA604BF220;
        Fri, 18 Jan 2019 11:33:01 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Fri, 18 Jan 2019
 11:32:52 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>,
        <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <chi-hsien.lin@cypress.com>, <pkshih@realtek.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] wireless: remove unneeded semicolon
Date:   Fri, 18 Jan 2019 11:32:15 +0800
Message-ID: <20190118033215.5904-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

remove unneeded semicolon

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h                     | 2 +-
 drivers/net/wireless/ath/ath6kl/init.c                    | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 drivers/net/wireless/ray_cs.c                             | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c      | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2034ccc..021eb30 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1986,7 +1986,7 @@ static inline const char *ath10k_wmi_phymode_str(enum wmi_phy_mode mode)
 		/* no default handler to allow compiler to check that the
 		 * enum is fully handled
 		 */
-	};
+	}
 
 	return "<unknown>";
 }
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 54132af..aa1c71a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1140,7 +1140,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 
 		len -= ie_len;
 		data += ie_len;
-	};
+	}
 
 	ret = 0;
 out:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d64bf23..ec12986 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -315,7 +315,7 @@ static int brcmf_sdiod_skbuff_read(struct brcmf_sdio_dev *sdiodev,
 		/* bail out as things are really fishy here */
 		WARN(1, "invalid sdio function number: %d\n", func->num);
 		err = -ENOMEDIUM;
-	};
+	}
 
 	if (err == -ENOMEDIUM)
 		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 33ad875..b58bb7b 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2211,7 +2211,7 @@ static void rx_data(struct net_device *dev, struct rcs __iomem *prcs,
 			untranslate(local, skb, total_len);
 		}
 	} else { /* sniffer mode, so just pass whole packet */
-	};
+	}
 
 /************************/
 	/* Now pick up the rest of the fragments if any */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index 1263b12..11f94b1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -332,7 +332,7 @@ static void _rtl8723be_phy_set_txpower_by_rate_base(struct ieee80211_hw *hw,
 				 "Invalid RateSection %d in Band 2.4G, Rf Path %d, %dTx in PHY_SetTxPowerByRateBase()\n",
 				 rate_section, path, txnum);
 			break;
-		};
+		}
 	} else {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 			 "Invalid Band %d in PHY_SetTxPowerByRateBase()\n",
@@ -374,7 +374,7 @@ static u8 _rtl8723be_phy_get_txpower_by_rate_base(struct ieee80211_hw *hw,
 				 "Invalid RateSection %d in Band 2.4G, Rf Path %d, %dTx in PHY_GetTxPowerByRateBase()\n",
 				 rate_section, path, txnum);
 			break;
-		};
+		}
 	} else {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 			 "Invalid Band %d in PHY_GetTxPowerByRateBase()\n",
@@ -694,7 +694,7 @@ static u8 _rtl8723be_get_rate_section_index(u32 regaddr)
 		else if (regaddr >= 0xE20 && regaddr <= 0xE4C)
 			index = (u8)((regaddr - 0xE20) / 4);
 		break;
-	};
+	}
 	return index;
 }
 
-- 
2.7.0


