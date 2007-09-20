Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46346
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXITNLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:11:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath5k and network manager
Date: Thu, 20 Sep 2007 15:11:23 +0200
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
References: <20070919214007.1a6a9b4a@freepuppy.rosehill> <43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com>
In-Reply-To: <43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709201511.23400.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 September 2007, Luis R. Rodriguez wrote:
> On 9/20/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > Network manager doesn't seem to detect ath5k. Perhaps it is because
> > it is name "ath0".  I think device should follow the convention of using
> > name "wifi0" rather than BSD convention of putting driver name in device name.
> 
> I couldn't agree anymore. But my ath5k kicks out a wlan%d name as with
> any other mac80211 driver. Is yours coming out to ath%d ?
> 
> ieee80211_register_hw():
> 
>         /* add one default STA interface */
>         result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
>                                   IEEE80211_IF_TYPE_STA);
> 


Probably udev renames it.



