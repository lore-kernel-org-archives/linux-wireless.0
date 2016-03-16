Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35193 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbcCPSzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 14:55:39 -0400
Received: by mail-qk0-f169.google.com with SMTP id o6so25089967qkc.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 11:55:39 -0700 (PDT)
Date: Wed, 16 Mar 2016 14:55:31 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Network Development <netdev@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
Message-ID: <20160316185531.GA1771@localhost> (sfid-20160316_195543_756737_926AF280)
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
 <CA+BoTQ=65mHN5iLnZjTE+tyEG7nfmCx4NZNbGRF6+VpRaNmOYw@mail.gmail.com>
 <CAA93jw5cUaj_qM+CYHHoRaghLDLC+BUgF4AjT=Oec+SB-zb74g@mail.gmail.com>
 <CAA93jw6tDdiYuginPbUY1DFJLiDxofHMFN6j2BvQPabPmBtuRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA93jw6tDdiYuginPbUY1DFJLiDxofHMFN6j2BvQPabPmBtuRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:36:31AM -0700, Dave Taht wrote:
> That is the sanest 802.11e queue behavior I have ever seen!  (at both
> 6 and 300mbit! in the ath10k patched mac test)

Out of curiosity, why does BE have larger latency than BK in that chart?
I'd have expected the opposite.

-- 
Bob Copeland %% http://bobcopeland.com/
