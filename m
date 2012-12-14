Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63882 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2LNTI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 14:08:29 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1674536wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 11:08:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121214190027.GE3078@localhost>
References: <20121214151442.GA10736@localhost> <CAPjQAd8-pFCRQLb=t4Cx+RaLbU8ZMT5_1Xc36sNsRgjm4NdgJw@mail.gmail.com>
 <20121214190027.GE3078@localhost>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 14 Dec 2012 11:08:08 -0800
Message-ID: <CAPjQAd81bm1sFy=feZCfgSYtVctkJHggNWEU7x7UrCiU-sfYoA@mail.gmail.com> (sfid-20121214_200833_935162_649A19EC)
Subject: Re: [PATCH/RFC] nl80211/cfg80211/mac80211: add NL80211_CMD_GET_MESH_SETUP
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 11:00 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Dec 14, 2012 at 10:17:24AM -0800, Javier Cardona wrote:
>
> Thanks for the review!
>
>> > +       setup->is_authenticated = ifmsh->security & IEEE80211_MESH_SEC_AUTHED;
>> +       setup->is_authenticated = !!(ifmsh->security &
>> IEEE80211_MESH_SEC_AUTHED));
>>
>> i.e. to force the value to be 0 or 1.
>
> Agreed if they were ints, but in this case .is_authenticated and
> .is_secure are type bool, so it shouldn't make a difference, right?

Yes, you are right.  Johannes pointed that out as well.

Sorry,

Javier

>
> --
> Bob Copeland %% www.bobcopeland.com
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
