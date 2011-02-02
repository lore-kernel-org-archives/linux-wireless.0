Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44821 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1BBCl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 21:41:26 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
	<AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
	<AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
Date: Tue, 1 Feb 2011 21:41:24 -0500
Message-ID: <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
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

On Tue, Feb 1, 2011 at 7:50 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>> I don't think it's good to advocate a custom driver.  They should be able
>> to use stock wpa_supplicant w/ nl80211 and put the extensions in the
>> hardware layer.
>
> Can you elaborate?

>From the wiki:

"The proper approach would be to provide a custom driver_nl80211_android.c
wrapper for the modified wpa_supplicant in Android."

I just don't think it's strictly necessary to ship a modified wpa_s.
Why is Android special when bog standard Linux gets by ok with
driver_nl80211?

-- 
Bob Copeland %% www.bobcopeland.com
