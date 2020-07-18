Return-Path: <SRS0=7u2v=A5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5D8C433E0
	for <linux-wireless@archiver.kernel.org>; Sat, 18 Jul 2020 12:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915A62073A
	for <linux-wireless@archiver.kernel.org>; Sat, 18 Jul 2020 12:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGRMTQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 18 Jul 2020 08:19:16 -0400
Received: from amphora6.sui-inter.net ([80.74.147.37]:50694 "EHLO
        amphora6.sui-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgGRMTQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Jul 2020 08:19:16 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2020 08:19:15 EDT
Received: from [IPv6:2a02:168:6182:1:ccfe:360a:938e:2c08] (localhost [127.0.0.1]) by amphora6.sui-inter.net (Postfix) with ESMTPSA id D056FB04140A
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2020 14:09:49 +0200 (CEST)
Authentication-Results: amphora.sui-inter.net;
        spf=pass (sender IP is 2a02:168:6182:1:ccfe:360a:938e:2c08) smtp.mailfrom=rs@hqv.ch smtp.helo=[IPv6:2a02:168:6182:1:ccfe:360a:938e:2c08]
Received-SPF: pass (amphora.sui-inter.net: connection is authenticated)
From:   Reto Schneider <rs@hqv.ch>
Subject: Wi-Fi Alliance Certification Wiki Entry
To:     linux-wireless@vger.kernel.org
Message-ID: <77603c59-ac2c-e084-110e-9ddcca346b4a@hqv.ch>
Date:   Sat, 18 Jul 2020 14:09:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi all,

I started a page in the Wiki about the Wi-Fi Alliance certification [1].

Initial content is a table with certified devices running a mainlined
driver. Both listed products are using the mt76. In case of the GARDENA
smart Gateway running on a MediaTek MT7688.

Are there any other certified devices running a mainlined 802.11 driver?
Maybe Intel devices? Asking such a seemingly trivial question here
because I have not (yet?) managed to use the search functionality on the
Wi-Fi Alliance in a sensible way.

Later on, I intend to extend the page soon, adding information about
features relevant for the Wi-Fi Alliance certification. Since I am
interested mainly in rtl8xxxu/rtl8188cu support, this will be the first
(and probably my only) entry. Any objections/suggestions/hints before I
do this?

Kind regards,
Reto

[1] https://wireless.wiki.kernel.org/en/users/wi-fi-alliance-certification
