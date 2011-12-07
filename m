Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1LGMwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 07:52:22 -0500
Received: by wgbdr13 with SMTP id dr13so1281519wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 04:52:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EDCE2CC.3060500@broadcom.com>
References: <4ED77C85.1050705@broadcom.com>
	<CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
	<4EDCE2CC.3060500@broadcom.com>
Date: Wed, 7 Dec 2011 13:52:21 +0100
Message-ID: <CACna6rwVRrm8YgvoYAmswru8nHXgytuiDRO2F2TQVZyxnfaV9w@mail.gmail.com> (sfid-20111207_135226_287479_DC4AB23D)
Subject: Re: bcma usage in isr context
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 5 grudnia 2011 16:27 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
>> You're right, we don't handle this properly. I'll try to send patch
>> today to make use of fixed windows. I've it here for some time
>> already, just didn't clean it enough.
>>
>
> Ok. For now I have a patch in the bcma read/write host_pci functions
> that solves it, but fixed bar windows are preferable.

Have you tested my patch? Does it solver your issue? I can't wait to
see bcma patches for brcmsmac :)

-- 
Rafał
