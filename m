Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19028C7EE23
	for <linux-wireless@archiver.kernel.org>; Mon, 15 May 2023 13:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbjEON3F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 May 2023 09:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241949AbjEON3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2023 09:29:04 -0400
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A463A1700;
        Mon, 15 May 2023 06:29:03 -0700 (PDT)
Received: from local
        by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pyYFg-0003D3-2D;
        Mon, 15 May 2023 13:28:38 +0000
Date:   Mon, 15 May 2023 15:25:59 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Peter Chiu <chui-hao.chiu@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Howard Hsu <howard-yh.hsu@mediatek.com>,
        MeiChia Chiu <MeiChia.Chiu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Lorenz Brun <lorenz@brun.one>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 1/2] dt-bindings: net: wireless: mt76: add bindings for
 MT7981
Message-ID: <0f04fcc9f81cd15a8ee2a9194cf95f2b924ef299.1684155848.git.daniel@makrotopia.org>
References: <cover.1684155848.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1684155848.git.daniel@makrotopia.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mediatek,mt7981-wmac compatible string entry.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 67b63f119f64..9081731611ef 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -28,6 +28,7 @@ properties:
       - mediatek,mt76
       - mediatek,mt7628-wmac
       - mediatek,mt7622-wmac
+      - mediatek,mt7981-wmac
       - mediatek,mt7986-wmac
 
   reg:
-- 
2.40.1

