Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55733 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbZDZKhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 06:37:42 -0400
Message-ID: <49F43975.2060106@gmail.com> (sfid-20090426_123800_234508_01AA0908)
Date: Sun, 26 Apr 2009 12:37:41 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com> <20090426020047.GA10885@hash.localnet>
In-Reply-To: <20090426020047.GA10885@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2009 04:00 AM, Bob Copeland wrote:
> On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
>> Hi guys,
>> do you remember some 5211 HW which didn't work with this?
>> --
>>
>> Set null key type even on ar5211, otherwise it en/decrypts every frame with
>> protected bit set which renders the card unusable on encrypted networks.
> 
> Not me.  I don't have the hardware, so I would say if your patch is known
> to work on a 5211 then we go with it.

Ok, thanks. Of course the HW I used (IBM T40 Thinkpad) needs the patch ;).
