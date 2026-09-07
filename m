Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011037.outbound.protection.outlook.com [52.103.39.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDCF248867;
	Mon,  7 Sep 2026 02:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788748174; cv=fail; b=Rlr4ax34zeMxHnK0aoG0xOzFMSm+tRKA5wAuO9ykuxRNl7ik9mq+HOkyV0nnycsBucCRyWqiJSrTmMfs1U5NHDzuqO2Nmhk+uV4qa+jbsg2BBriWKfXBoRyesVh9hn+K+7arT3ZA6dRhJlzkoWmkTORagvpJoLRitzCMant3Fy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788748174; c=relaxed/simple;
	bh=u6Es2K/nr/KA+jfwTIu3Jj6ob/ZQhE9LSr0qRSuX1hk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lqqgN/DuofVACTFpRKxrwbRVwz90fIorxulV3JldNZiGp2xYvv/xIfHSSh1I7ba6Yy5O5w5WP4R0h/E9KIDB0tYsAmo7y7Uut6TCqHp5wJw2KrNqBxXoXMeOT4lTIwUZEnikIkjYO8v0OfN9iE6Ne+M8i+dXOtto8TBfvPBNrH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=DxE4IPqP; arc=fail smtp.client-ip=52.103.39.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="DxE4IPqP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLVA0QTd2WpTwd/Uh0VAuaZ7wRxh1sXH2RYCsyOsbJ4e4meTdw0042Fnn//hE4N00f7omb3AVWmD98h9FPf25WmG7BlHcnH7A5E1RSx1PwTa3i/zdVTeIPGl/N0g6iSEzNbk3aMuCCZ0PCr/2eGpEe3OvIOk8iNGZeZv4SGt9jQw+NOh7a2dclFz7UWTmoR7UzmlJ9Tlp3ZYI/dfQrkRSuYCr1bZKm9G6khx1dZEDfQ3iuZNOylOGBBD9uY4RAikOS8RlrUSsS23XcPfMjuUFKBGQQJpAHB3mdsOun5ue5qKr6vvlq3zGcQmBKJiKWZ0WJ53sFOiv6HXnTaOovrcAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iis6Av/hG0iUXBwU34p/6HpL7U7dM/brQgeMGmYSXPM=;
 b=ruiI4fH7EfR/CuEjPZnNceYbLhEU09x9P+c06IyoanaIX621Ch95V0FlmuwS+PjgNd1lBa5ANvahgyNl5iyZW4wpGTuLuujEAiTGB6BYaTrF8SXYVekcCzKFLlj9WV6LGr/Q26tInTk4Pb/WXaEHIW/xcuslIFuxnMFxw1fFqRn4OP4LX3ELmNt7LoDpnlWOEXbGbqsU6qdeo8tD4e3tzooEeCiIqhQoSXyN5pPkh7z29qK2V4BNwa5UioRTYnjEb/6gLyeRMLXQwvnvq8sCwSOzM3BJfb7m5bPgZAP5iTHLhrGwGlCatL11Cm0pcbxg1EMg0C4IL0qnESkcc2JOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iis6Av/hG0iUXBwU34p/6HpL7U7dM/brQgeMGmYSXPM=;
 b=DxE4IPqPd2HHJJM8VzuOD8fj3Cv02sBfGJROVBlrxc+J1vq3Maxm1yti9ieNJdKwZGKlVNdg7/k0KrhsVxtJarSDhS2mr9M6gRuZ7vHKh4HXImw7MUOUXZfeLkeKWyTD9ipGI6SrEuHeie/S38cp3ZqqrAOvyaHv27P8tP6ykGTtO+TidVPGCY9gEGa+rLy8NdtcCebLF4OMimMnSGOd3cPApgtiM0EbwpKcGOhQFroIAdUehVOHnh1y3PDhyJQ6BYbVbzDVmRw4AfEEu5QBBsMvO4lADkZZZzKPlDRMhwhkC6YaaTjHfj5HCAsjk2ENgcV/bSYgUIwPJft/DtwyYw==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by DB9P251MB0077.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:2c9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 02:29:30 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 02:29:30 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: srini.raju@purelifi.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: plfxlc: validate received USB transfer length before processing
Date: Mon,  7 Sep 2026 02:29:27 +0000
Message-ID:
 <AS8P251MB00014A99D4C6A731FBCF5593C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0238.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::11) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907022927.499358-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|DB9P251MB0077:EE_
X-MS-Office365-Filtering-Correlation-Id: 488311a9-454b-4520-d4fb-08df0c87d825
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25031999004|23021999003|37011999003|12121999013|15080799012|2604032031799003|19110799012|8060799015|11091999009|51005399006|55001999006|24021099003|41001999006|25010399006|5072599009|5062599005|4140399003|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yAcKzsX7JRkrBlvD0kV5tl4rg3v3jcnwkYrbT+QC+tlOSwol4ikUw9rgsYUE?=
 =?us-ascii?Q?g9l4298ye+wHwXgPauS6hdfTOTgIiy568ZpLT37hRTeYV7EkQm2XTCu4eETn?=
 =?us-ascii?Q?b9OJWeJOQNp+x+ty9Racj58kziEmYUEAOcuHySdWdWIWXcR2c8fZuhzT7LCj?=
 =?us-ascii?Q?gOfQdTreIuQ/kProSR3flDKXJPWm72vg2h1HRzf1GvpfmdK9QHniSXw+Yukj?=
 =?us-ascii?Q?fQWyMgHi9dRdvNF/4fyQ67DbnTMqMoyl573nIcpuCMevWRANBo0/7jgfRH8K?=
 =?us-ascii?Q?AElsaZ52hgUYEj2P/y75tRKJChmJ+8V7TfR9CCHOucZiHm/iTVUjslRH8rOw?=
 =?us-ascii?Q?8J7rYJk2aN9IAnIR5nYKE2WvMu019WkGWcgxy5ttFEkq8byHW/NXGRR7dMCd?=
 =?us-ascii?Q?xeVBvcV0ZAzypKQ7++WlGE2YD/5l66mGfoq4AeLz68k3Ar6PA4tOyTVRQNvp?=
 =?us-ascii?Q?pDlRNjzRNXixVqwuy+qtY41afBm9RVd4o+GUqz0CM/CTRynyhRC+vsxqPIpf?=
 =?us-ascii?Q?8u5k6DGP8QXpkQXg8WQXY59BjpKr0nrz/mCMQHlVa8LK/+9xFfFcV6yqkDtI?=
 =?us-ascii?Q?GYGk05hc1JivP75CkxwLrh4UkHkEW/1WSxdL4Tgd2piZEEYxso/UtTDZ27E1?=
 =?us-ascii?Q?LeA5j9yiuoS+tD8yzcRjP9mRM8QBNnDQasTQ6TdC0lEqIchMv4pDGf/oxesf?=
 =?us-ascii?Q?opsmOi5XrfnYj5TcEUIrCjDp5Hupwg6/yFYPbq0WQzJg+x6YjbWaKiwUNm5S?=
 =?us-ascii?Q?h7xycgaZJ0wfI/v8+5kQk+in5T+WmcAWWAw3lwnnWVcfODTnGjRmRVLZV+Xf?=
 =?us-ascii?Q?n+oFOizWEzSmy62sASchiMwKP0S/Ix6hLH/TiBpy0tjN7pNM1bwFuo2aYNh5?=
 =?us-ascii?Q?ntae+oh05ZFDddbKAUSpmGtQLsWnm1Igsz1be4n1nTMaF1H178XwanTTKVwz?=
 =?us-ascii?Q?CX+EFGsFWsvsxGWO6WRvK168KLlt1ApzK3SOdoKvB3AFE+L8yK3Ul7gBiCU1?=
 =?us-ascii?Q?6Ihm7DqiODGa2RgkBTDhX6oscP7QjCo3tD5aKbMvhBlkbgH2NHXi778J4Ph1?=
 =?us-ascii?Q?TyiBzDiWv68/bcsyg+3f8kTMXMdaPsGb8M9bdIk4MW5QjByppn62MndUqDHD?=
 =?us-ascii?Q?4kVaMdkOC6hAGiU3UUTNSRWLxO4tFkAppqYuASC3MRLKvnbk6k3SXebilgAh?=
 =?us-ascii?Q?86ARp4thn11BLf4ODtVmr+D/OfDzgGliScWIiZMmHW6LQKhiimop7RCUNcM?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?241xc/XLrfoUJLZk4mR5+Jap/IquQT5jv70YPEQBq4yF5+Cgh69NV9bTY/Ex?=
 =?us-ascii?Q?8EbXT/fv1B/y8ssvMqgtBSE2xNHGLAWhGoFjtpJjfW8oh0Wttw8nwJVY/Rmx?=
 =?us-ascii?Q?vOmVXon8MWGdBPgK1j2HaGLo9CfmCFF4WE1aasrR9LVo5KJqy6h/iWM+oVDP?=
 =?us-ascii?Q?81And2j8G/kLVb+hP+DFOb86A7PkyEf+BmxOrFC2ID4SScOk/Ybq2g4mn/U6?=
 =?us-ascii?Q?X/7FJvFyiPOpCWx5E97fNyhOj/+3/+hfFGShj/Y2g8St+8vxO0a2dRXJB+2l?=
 =?us-ascii?Q?3IEvdF2hTZHLxk70j4tMu0M9TwbVLMRULHWbwT6Mh0kuJcgjJf1/4uaU8CbD?=
 =?us-ascii?Q?sEJS8Hf/7miTxGW57gDDVXZgRhT/0X0f3CVBwpNffx4Xf/Lfy4tjil9gT+St?=
 =?us-ascii?Q?WmqUBz8FyeG/zhfwUySCnIu/DfRXeFjC4U/5i9wcwbz98FrB+jGfY76PLRQ9?=
 =?us-ascii?Q?npYuyALcU7+WjQRr32Efw902ttG/Hi21yQ6FJP8DFbMsUdMnerZYkW6oE5Zo?=
 =?us-ascii?Q?9yz2l6jobpj/1DJA+coIn4dEtRMm01DyKfZ9Bs4v/X6k1N74tYkW35Mketg3?=
 =?us-ascii?Q?N+bqhYF4k236GOitDgAdTuqIGhKUfNCwEDN4jL14uEKp3WAvNlna9W8H5YQN?=
 =?us-ascii?Q?NdYRbvZnXRhpr36MB59mPXB8Dir+yiifssGF+OCRSo70mt3+xafmTK9zl8j2?=
 =?us-ascii?Q?9MGacE3hy+qF/KhKLNDowe+GVJgQ/7yD9a6fyuhK8uEWZgwnjK60Eywi0ogO?=
 =?us-ascii?Q?NlU2LYG671pcwVKYw0ptKPcR1gPu5E+Lb+2Z7iPD2x+AZe+qPP6KEGpaRHSy?=
 =?us-ascii?Q?Kucym41ybEMv+bahu3e5roqnud9YQQq5e1MFZs5YPCqPmiyjF7a4e6dwf33Y?=
 =?us-ascii?Q?Ci7PgkdZR6FNO2woUq4AMZXb8B8XPfcN18Y6LLq8lBER020qaHLCzAPL8Awx?=
 =?us-ascii?Q?8T7yEsX14cevCV/rrFaDOH5VfE14Pu8BiCiGLkD27A52Jzk1S9y9kwRzBgDQ?=
 =?us-ascii?Q?dBsEh8n2lYVN8bAW2tIw2uzkhgXItnA0Ow9nZKysisWe1reENXOxCSC1+qsE?=
 =?us-ascii?Q?SfQhW2KTr4J2y7ETQC2ao7ybGzhfcvRkmbGNuFfGs/VZbY7eMuUA9lfzXUFS?=
 =?us-ascii?Q?8TLIf5EKWZOIi+uSXsxadXjBr+0IauIx1ftDdGKTMfsyQms4t0EhZz0QM9Ib?=
 =?us-ascii?Q?29eJRuAGL6UQihJQ45l23YSxi+5uHVM0wwCXlljA0VVfAQj0I2SeKD0g3NcJ?=
 =?us-ascii?Q?RFwzY7JxFjbt/43QlukAsqBwqxqB5+tZ0Zy1Ot0+KXcYZmYYupfZM9OThT5c?=
 =?us-ascii?Q?az3w7fJYkFCFjICX3sDObTmCXdNrmnYfm81mO52cg1Z54XRwbpe5qA5pElKE?=
 =?us-ascii?Q?moFCYfi0pv3VCyQGJ2maN+SVW7II7A1Ay9PTZlH7KMx1e9KFdphSaqtdzcKH?=
 =?us-ascii?Q?QlEsRq9mojoto6xqBOSAE+5fBCzJ0wDW?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 488311a9-454b-4520-d4fb-08df0c87d825
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 02:29:29.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P251MB0077

rx_urb_complete() was computing the received data length from a
device-supplied field using le32_to_cpu(), but the protocol actually uses
big-endian byte order.  More critically, this device-derived length was
passed to plfxlc_mac_rx() without any validation against the actual USB
transfer size (urb->actual_length), allowing a malicious or malfunctioning
device to cause out-of-bounds memory access.

Fix this by:

1. Using urb->actual_length in rx_urb_complete() instead of parsing a
   length field from the device-supplied buffer with the wrong endianness.

2. Adding minimum length validation in plfxlc_mac_rx() before accessing
   the rx_status header and payload_length field.

3. Validating payload_length against the actual received length to prevent
   buffer over-reads.

4. Moving the plfxlc_filter_ack() call to after the buffer pointer has
   been advanced past the rx_status header and length field, so it receives
   a pointer to the actual 802.11 frame header instead of the rx_status
   struct.  The old code passed the raw buffer (pointing to struct
   rx_status) cast to struct ieee80211_hdr, which is a type confusion bug.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/purelifi/plfxlc/mac.c | 17 ++++++++++-------
 drivers/net/wireless/purelifi/plfxlc/usb.c |  5 ++---
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
index a900421753ac..d2690cce796a 100644
--- a/drivers/net/wireless/purelifi/plfxlc/mac.c
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -407,6 +407,9 @@ int plfxlc_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
 	if (!mac->vif)
 		return 0;
 
+	if (length < sizeof(struct rx_status) + sizeof(u32))
+		return -EINVAL;
+
 	status = (struct rx_status *)buffer;
 
 	memset(&stats, 0, sizeof(stats));
@@ -425,19 +428,19 @@ int plfxlc_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
 
 	mac->crc_errors = be64_to_cpu(status->crc_error_count);
 
-	/* TODO bad frame check for CRC error*/
-	if (plfxlc_filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
-	    !mac->pass_ctrl)
-		return 0;
-
 	buffer += sizeof(struct rx_status);
 	payload_length = get_unaligned_be32(buffer);
+	buffer += sizeof(u32);
 
-	if (payload_length > 1560) {
+	if (payload_length > 1560 ||
+	    payload_length + sizeof(struct rx_status) + sizeof(u32) > length) {
 		dev_err(plfxlc_mac_dev(mac), " > MTU %u\n", payload_length);
 		return 0;
 	}
-	buffer += sizeof(u32);
+
+	if (plfxlc_filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
+	    !mac->pass_ctrl)
+		return 0;
 
 	fc = get_unaligned((__le16 *)buffer);
 	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 6d24086eb8b7..c33b9131bfdd 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -117,10 +117,9 @@ static void rx_urb_complete(struct urb *urb)
 	}
 
 	buffer = urb->transfer_buffer;
-	length = le32_to_cpu(*(__le32 *)(buffer + sizeof(struct rx_status)))
-		 + sizeof(u32);
+	length = urb->actual_length;
 
-	if (urb->actual_length != (PLF_MSG_STATUS_OFFSET + 1)) {
+	if (length != (PLF_MSG_STATUS_OFFSET + 1)) {
 		if (usb->initialized && usb->link_up)
 			handle_rx_packet(usb, buffer, length);
 		goto resubmit;
-- 
2.43.0

