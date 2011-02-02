Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54718 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1BBApN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:13 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
Date: Tue, 1 Feb 2011 19:45:12 -0500
Message-ID: <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>,
	Sree Durbha <Sree.Durbha@atheros.com>,
	Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
	Xin Jin <Xin.Jin@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 1, 2011 at 6:29 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> We get poked every now and then for Android support for mac80211 or
> cfg80211 drivers. Since the questions is quite common I figured It'd
> be good to document what needs to get done for this. Android folks,
> you listening?
>
> http://wireless.kernel.org/en/developers/Documentation/Android
>
> If you already have worked on this or are going to please feel free to
> update the wiki so no one else re-invents the wheel.

I don't think it's good to advocate a custom driver.  They should be able
to use stock wpa_supplicant w/ nl80211 and put the extensions in the
hardware layer.

-- 
Bob Copeland %% www.bobcopeland.com
