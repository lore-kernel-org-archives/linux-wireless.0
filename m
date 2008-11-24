Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:20918 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYKXUww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 15:52:52 -0500
Received: by yw-out-2324.google.com with SMTP id 9so933171ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 12:52:50 -0800 (PST)
Message-ID: <40f31dec0811241252k76bb76b9u2766173ac914c60@mail.gmail.com> (sfid-20081124_215255_102338_914E97A8)
Date: Mon, 24 Nov 2008 22:52:50 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Richard Farina" <sidhayn@gmail.com>
Subject: Re: [Fwd: please don't regress ath5k.h]
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Renzmann" <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <40f31dec0811241225s1109b83aw244c96f2cb8ed59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <492A14A7.4040808@gmail.com>
	 <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org>
	 <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com>
	 <40f31dec0811241225s1109b83aw244c96f2cb8ed59@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/24 Nick Kossifidis <mickflemm@gmail.com>:
>
> CHAN_DEBUG is an option i used a lot of time ago while debuging
> channel flags on madwifi-old-openhal. When we switched to mac80211 and
> ath5k, this code got useless, it just changes the maximum number of
> channels the driver allocates and has nothing to do with debuging,
> that's why i've put that TODO there. If you just want to register* more
> channels on mac80211, you can always change or redefine ATH_CHAN_MAX.
>

*Correction: allocate

ATH_CHAN_MAX has nothing to do with how many channels we register,
it's jut used on base.h to set how many channels we 'll have on our
channel array.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
