Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:23409 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZAETdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 14:33:20 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2681449fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 11:33:17 -0800 (PST)
Message-ID: <3ace41890901051133t13c827ubcd0416503b7b878@mail.gmail.com> (sfid-20090105_203324_613455_8F6D56B4)
Date: Mon, 5 Jan 2009 19:33:17 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: rate instability in wireless stack
Cc: "Andi Kleen" <andi@firstfloor.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <49623CEA.4080407@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090105050248.GG496@one.firstfloor.org>
	 <49620BE5.9030507@openwrt.org>
	 <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org>
	 <20090105152410.GT496@one.firstfloor.org>
	 <49622686.9050005@openwrt.org>
	 <20090105163553.GU496@one.firstfloor.org>
	 <49623712.4060106@openwrt.org>
	 <20090105171105.GW496@one.firstfloor.org>
	 <49623CEA.4080407@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This sounds a bit like what is mentioned in this bug report - (no solution yet,
but the symptom seem similiar).
http://bugzilla.kernel.org/show_bug.cgi?id=12131

On Mon, Jan 5, 2009 at 5:01 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Andi Kleen wrote:
>>> According to the rate control's view, only the 1M has a usable
>>> success probability. It's rather insteresting that 11M is the only
>>> other rate that had some successes. With this kind of results, the
>>> only two options that I can think of are either a systematic tx
>>> status reporting error (false negative for the IEEE80211_TX_STAT_ACK
>>> flag), or something PHY related.
>>
>> Ok. Any more data I should provide to help tracking this down?
>> Do you want the same from the RaLink?
> Yes, It'd be interesting to see if the table looks similar or if
> more rates work.
>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
