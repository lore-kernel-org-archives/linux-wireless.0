Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:44901 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751462AbeCETbg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 14:31:36 -0500
Subject: Re: [PATCH 1/2] ath10k: Add WMI FWTEST command support
To: Peter Oh <peter.oh@bowerswilkins.com>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
 <1520233148-26050-2-git-send-email-akolli@codeaurora.org>
 <94f133b3-ee5d-6ed8-d7e8-20dff9aaede2@bowerswilkins.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <fd392368-5535-d10e-b1bb-934e45fd9c43@dd-wrt.com> (sfid-20180305_203139_775167_D2464D24)
Date: Mon, 5 Mar 2018 20:31:33 +0100
MIME-Version: 1.0
In-Reply-To: <94f133b3-ee5d-6ed8-d7e8-20dff9aaede2@bowerswilkins.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 05.03.2018 um 19:48 schrieb Peter Oh:
> From: Sathishkumar Muruganandam <murugana@codeaurora.org>
>> This patch adds support for WMI_FWTEST_CMD.
>> This command is used for setting the wifi parameters.
>
> It's too lack of information in commit message.
> You should add such what values are acceptable for which purpose by 
> each param_id and param_value to make this changes meaningful to 
> community.
i agree. i reviewed the firmware sourcecode to find out what its doing, 
but also within the firmware is almost undocumented. its a bunch of 
undocumented
numeric parameters with undocumented behaviour.
if qca is willig to document this feature it might be included.

Sebastian


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
