Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:36939 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751548AbdJWTfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 15:35:15 -0400
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
 <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com>
 <fb5f8df1-aa9a-2646-5f98-afc852acce5c@qti.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <3866abd1-e68c-ff83-0463-f4c4042a69b6@dd-wrt.com> (sfid-20171023_213518_907482_E33B5B4B)
Date: Mon, 23 Oct 2017 21:35:09 +0200
MIME-Version: 1.0
In-Reply-To: <fb5f8df1-aa9a-2646-5f98-afc852acce5c@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.10.2017 um 16:24 schrieb Vasanthakumar Thiagarajan:
> On Saturday 21 October 2017 01:41 AM, Sebastian Gottschall wrote:
>> i suggest the following patch on top of yours. please tell me if my thoughts are correct here. its mainly a guess
> I agree we need to take care of this for newly added ciphers as well. How about making it as a separate patch
> to make the patch bit smaller and to reduce the difficulties in back porting it for ciphers supported for long
> time?
the patch for these both ciphers doesnt make it bigger. just a few 
lines. the main problem right now is that the original patch without my 
enhancements isnt working. it breaks encryption
> Vasanth


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
