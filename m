Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36419 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338AbcCQLM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 07:12:59 -0400
Received: by mail-qk0-f171.google.com with SMTP id s68so33438471qkh.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 04:12:57 -0700 (PDT)
Date: Thu, 17 Mar 2016 07:12:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Jasmine Strong <jas@eero.com>, Dave Taht <dave.taht@gmail.com>,
	Network Development <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	make-wifi-fast@lists.bufferbloat.net
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
Message-ID: <20160317111248.GC1238@localhost> (sfid-20160317_121308_705385_3604CF93)
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
 <CA+BoTQ=65mHN5iLnZjTE+tyEG7nfmCx4NZNbGRF6+VpRaNmOYw@mail.gmail.com>
 <CAA93jw5cUaj_qM+CYHHoRaghLDLC+BUgF4AjT=Oec+SB-zb74g@mail.gmail.com>
 <CAA93jw6tDdiYuginPbUY1DFJLiDxofHMFN6j2BvQPabPmBtuRw@mail.gmail.com>
 <20160316185531.GA1771@localhost>
 <CAGyitvMDEUiNx7HD=XKjXNHnFvZ_gxD_BbQx3AP-57_+dBeD4A@mail.gmail.com>
 <CA+BoTQnFN6VANn=5EUvHc0Dbfh4Zv0HraOto2ySN3_HdOpD7Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+BoTQnFN6VANn=5EUvHc0Dbfh4Zv0HraOto2ySN3_HdOpD7Sg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 09:55:03AM +0100, Michal Kazior wrote:
> If you consider Wi-Fi is half-duplex and latency in the entire stack
> (for processing ICMP and UDP_RR) is greater than 11e contention window
> timings you can get your BE flow responses with extra delay (since
> other queues might have responses ready quicker).

Got it, that makes sense.  Thanks for the explanation!

-- 
Bob Copeland %% http://bobcopeland.com/
