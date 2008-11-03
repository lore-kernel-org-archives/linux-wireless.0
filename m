Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:57241 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYKCOmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 09:42:36 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2610467rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 06:42:36 -0800 (PST)
Message-ID: <b6c5339f0811030642x4f62255em61c546b2aa89e31b@mail.gmail.com> (sfid-20081103_154259_423919_D4D27A8D)
Date: Mon, 3 Nov 2008 09:42:35 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Nick Kossifidis" <mickflemm@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4908B754.1050400@tpi.com>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 <1225699482.3619.34.camel@johannes.berg>
	 <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 3:26 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> As can be seen from the patch suggested what some drivers will end up
> doing is just ignoring failures but I guess that can be up to the
> drivers to deal with as you are suggesting.

FWIW my patch returning 0 in every case wasn't to be taken seriously.
However, in my case I got a never-ending series of such warnings which
was not a particularly nice failure scenario as opposed to something
like "ath0: hardware is hosed, disabling."  That's certainly something
the driver could do (but then why bother returning anything from the
function?)

-- 
Bob Copeland %% www.bobcopeland.com
