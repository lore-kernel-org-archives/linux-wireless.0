Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:12331 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYF1LTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 07:19:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so824669wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 04:19:23 -0700 (PDT)
Message-ID: <69e28c910806280419r40eb037cv858f89b8f2638ef2@mail.gmail.com> (sfid-20080628_131954_811924_2B260EB4)
Date: Sat, 28 Jun 2008 13:19:22 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Missing channels on iwl3945 shipped with 2.6.26-rc8
Cc: janconrads@gmx.de, linux-wireless@vger.kernel.org
In-Reply-To: <1214640029.5507.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4865B3C6.1030007@gmx.de> <1214640029.5507.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 10:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> vermagic:       2.6.26-rc8-jan SMP mod_unload modversions CORE2
>> parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code =
(charp)
>>
>> I read, that 64 should be ok, but if I set any option only the 2.4GH=
z
>> Band is listed. For germany 276 is a common valve on atheros cards, =
but
>> this doesn not work, too.
>
> As you can see, it's a charp, i.e. a string. Try setting "EU".
>
> johannes
>

Does 2.6.26-rc8 (not 2.6.26-rc8-wl) have "EU", or only "US" and "JP"?
AFAIK it only has "JP" besides "US", though I may be wrong.

G=E1bor
--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
