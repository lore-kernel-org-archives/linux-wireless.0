Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33541 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2CZJnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 05:43:37 -0400
Received: by wibhq7 with SMTP id hq7so4183746wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 02:43:36 -0700 (PDT)
Date: Mon, 26 Mar 2012 11:43:31 +0200
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120326094331.GA4856@stt008.linux.site> (sfid-20120326_114341_390563_C8732D98)
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com> <4F6D939F.3030206@broadcom.com> <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com> <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com> <4F7035AD.1080503@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4F7035AD.1080503@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2012-03-26 a las 11:23 +0200, Arend van Spriel escribió:
> On 03/24/2012 12:21 PM, Camaleón wrote:
>> 2012/3/24 Camaleón<noelamac@gmail.com>:
>>
>>> I will keep and eye on this, bu all seems good and working fine now.
>>
>> Okay, I got another trace :-(
>>
>> NetworkManager asked for the password (which was already set and
>> printed at the input box, I didn't have to type it again) and
>> reconnected fine but it logged the trace at /var/log/messages.
>>
>> See attached files.
>>
>
> The WARNING message is preceded by a cfg80211 message regarding world  
> regulatory domain. I suspect there is a relatio, but not sure what it  
> is. Regarding channels 12 and 13 I will come up with a fix today and  
> send you the patch to try.

Based on a user advice, I have set the regulatory domain to ES (Spain) 
and I had not experienced another trace since that (the netbook was 
running yesterday all day long).

Still, I will keep my "three" eyes over it and test any pacth you 
consider convenient. Will comment back as soon as I get another trace 
or there's something worth to add :-)

Greetings,

-- 
Camaleón 
