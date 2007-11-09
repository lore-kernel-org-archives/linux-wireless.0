Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:38728 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbXKILNl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 06:13:41 -0500
From: Claudio Matsuoka <claudio@mandriva.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RTL8187 rate control problems
Date: Fri, 9 Nov 2007 09:13:11 -0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711061323.16302.claudio@mandriva.com> <200711061947.21927.flamingice@sourmilk.net> <1194445243.4470.25.camel@johannes.berg>
In-Reply-To: <1194445243.4470.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711090913.12656.claudio@mandriva.com> (sfid-20071109_111346_888039_3E015D08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 November 2007 12:20:43 Johannes Berg wrote:

> > There's no easy way to do tx ack reporting on the rtl8187.
>
> This also means it doesn't show you outgoing frames on a monitor. We
> really need to find a solution here that takes into account our current
> use of tx status reports for outgoing frame monitor as well as rate
> control.

That would be important since the current situation for users of rtl8187 and 
possibly other chips with similar problems is to be limited by default to a 
very short range, or manually set bitrates (or resort to some ugly hack to do 
that). By the way, setting the bitrate back to "auto" isn't working as well 
in the rtl8187 once you switch to fixed, but given the current situation it's 
more a feature than a bug :)

