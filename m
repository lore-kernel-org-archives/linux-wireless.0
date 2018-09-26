Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D4FC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F20214FF
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aqahD1aK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32F20214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbeIZWNS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 18:13:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41628 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727570AbeIZWNS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 18:13:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8QFP0bm008065;
        Wed, 26 Sep 2018 08:59:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=izR9/iS3wS8IVy0PdUwNdyq6IqmuZ84MfG12lp5U+5U=;
 b=aqahD1aKBA//ggeGrRNni5sTgpj7wkXN57V3UaaODLuQhsUvqzPCWm3C2xH896gpS093
 GEPlocoxu0pg6GA3wrzE95yQNpfo+HkrF7vnuApuwCrZ/o0XjraG/wpatF1W3bkqCHRS
 ACr8bMC4XAZqPGuzDSkkGM+eJFshVS2aj+zEk8ssGWtmBCq/ytEQqeiGtu9nmwPv4lfy
 cGc3ncSYbd+uu5VVkxPJVCmUBER+bC+LkrXjyfYkht/9jObuCiF+MKrUB1khlOmx5EoZ
 1EMQZr1pT5oALTLKT8pSBe7o8/a7k45E9otGSijXZ04YQZGgzy4y/0OOx08v4uHhJpPw iQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2mnk3k5qmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Sep 2018 08:59:40 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1210.3; Wed, 26 Sep
 2018 08:59:39 -0700
Received: from SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95]) by
 SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95%20]) with mapi id
 15.00.1210.000; Wed, 26 Sep 2018 08:59:39 -0700
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Sachin Patki <spatki@marvell.com>,
        LakshmiNarayanan Ramachandran <laksnr@marvell.com>
Subject: pull-request mwifiex-firmware 2018-09-26
Thread-Topic: pull-request mwifiex-firmware 2018-09-26
Thread-Index: AQHUVbHt9I2/i+qHTESgc2Ox4pSZjQ==
Date:   Wed, 26 Sep 2018 15:59:39 +0000
Message-ID: <1537977579442.29538@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.93.176.43]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-09-26_08:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=653 adultscore=4 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1807170000 definitions=main-1809260149
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following changes since commit 0ced724f6ed564a5e1602808163db7cfa4697f39=
:=0A=
=0A=
  linux-firmware: update Marvell USB8801 B0 firmware image (2018-07-20 11:0=
0:29 +0530)=0A=
=0A=
are available in the git repository at:=0A=
=0A=
  git://git.marvell.com/mwifiex-firmware.git=0A=
=0A=
for you to fetch changes up to 52b23a9326fd8bb468b1b9e4c1816bf08bc2bc3c:=0A=
=0A=
  linux-firmware: add Marvell SD8997 firmware image (2018-09-26 21:25:40 +0=
530)=0A=
=0A=
----------------------------------------------------------------=0A=
Ganapathi Bhat (1):=0A=
      linux-firmware: add Marvell SD8997 firmware image=0A=
=0A=
 WHENCE                     |   3 +++=0A=
 mrvl/sdsd8997_combo_v4.bin | Bin 0 -> 621896 bytes=0A=
 2 files changed, 3 insertions(+)=0A=
 create mode 100644 mrvl/sdsd8997_combo_v4.bin=
