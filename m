Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092A7C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA05F2184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 14:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfCTOrK convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:47:10 -0400
Received: from mail.3eti.com ([65.220.88.139]:55094 "EHLO mail.ultra-3eti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfCTOrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 10:47:09 -0400
X-ASG-Debug-ID: 1553093180-05429962e503ee0001-9xRsGE
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id NLtuMqNy4XuDTwve (version=TLSv1.2 cipher=AES128-SHA256 bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2019 10:46:20 -0400 (EDT)
X-Barracuda-Envelope-From: Chaoxing.Lin@ultra-3eti.com
Received: from EXCHMBX01.rock.corp ([192.168.200.89]) by RockMX01.rock.corp
 ([fe80::5def:57af:7b19:da5a%14]) with mapi id 14.03.0415.000; Wed, 20 Mar
 2019 10:46:19 -0400
From:   Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: crda package not compiled with openssl-1.1.1
Thread-Topic: crda package not compiled with openssl-1.1.1
X-ASG-Orig-Subj: crda package not compiled with openssl-1.1.1
Thread-Index: AdTfK1QUqA76R3sYRoKMwwKDHrUkXQ==
Date:   Wed, 20 Mar 2019 14:46:19 +0000
Message-ID: <E0249DC1E88AC941A5535F80928B4ADF124714D8@EXCHMBX01.rock.corp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: rockmx01.rock.corp[192.168.200.4]
X-Barracuda-Start-Time: 1553093180
X-Barracuda-Encrypted: AES128-SHA256
X-Barracuda-URL: https://192.168.200.200:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at ultra-3eti.com
X-Barracuda-Scan-Msg-Size: 153
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.68873
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

USEOPENSSL=1 make
None of crda released package can compiled with openssl-1.1.1 which removed "struct bignum_st"
Can anyone update crda packages?


