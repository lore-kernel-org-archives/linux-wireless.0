Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4834 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab2CZJYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 05:24:11 -0400
Message-ID: <4F7035AD.1080503@broadcom.com> (sfid-20120326_112414_820620_48B7EDEE)
Date: Mon, 26 Mar 2012 11:23:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
In-Reply-To: <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2012 12:21 PM, Camaleón wrote:
> 2012/3/24 Camaleón<noelamac@gmail.com>:
>
>> I will keep and eye on this, bu all seems good and working fine now.
>
> Okay, I got another trace :-(
>
> NetworkManager asked for the password (which was already set and
> printed at the input box, I didn't have to type it again) and
> reconnected fine but it logged the trace at /var/log/messages.
>
> See attached files.
>

The WARNING message is preceded by a cfg80211 message regarding world 
regulatory domain. I suspect there is a relatio, but not sure what it 
is. Regarding channels 12 and 13 I will come up with a fix today and 
send you the patch to try.

Gr. AvS

