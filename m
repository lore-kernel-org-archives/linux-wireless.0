Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaEFMam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 08:30:42 -0400
Message-ID: <1399379427.4218.23.camel@jlt4.sipsolutions.net> (sfid-20140506_143045_814901_BBB1E2CA)
Subject: Re: [PATCH 1/2] mac80211: add no update durationId bit in radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@venema.h4ckr.net>
Date: Tue, 06 May 2014 14:30:27 +0200
In-Reply-To: <CALDuf6iCmceJG1kGsJgii8oe65ivnQEsAgqPZ_LTAHoGo0OPZg@mail.gmail.com> (sfid-20140506_134430_880964_F5481BC8)
References: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com>
	 <1399358996.4218.0.camel@jlt4.sipsolutions.net>
	 <CALDuf6iCmceJG1kGsJgii8oe65ivnQEsAgqPZ_LTAHoGo0OPZg@mail.gmail.com>
	 (sfid-20140506_134430_880964_F5481BC8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 13:44 +0200, Marek Kwaczynski wrote:
> Hi Johannes,
> 
> I can achieve the same result without changing radiotap header if
> durationID filed won't be updated for all injected frames. What do you
> think about it?

I think that's a terrible idea, particularly backward compatibility with
older hostapd versions.

johannes

