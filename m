Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1JTLQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:16:57 -0400
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
In-Reply-To: <1319072606-28291-6-git-send-email-thomas@cozybit.com> (sfid-20111020_030414_127381_5EBD73AF)
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	 <1319072606-28291-6-git-send-email-thomas@cozybit.com>
	 (sfid-20111020_030414_127381_5EBD73AF)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 13:16:52 +0200
Message-ID: <1319109412.3959.7.camel@jlt3.sipsolutions.net> (sfid-20111020_131700_735137_8BB8BDDB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-19 at 18:03 -0700, Thomas Pedersen wrote:
> Include the WMM IE in mesh peering and beacon frames. This is needed
> tell any potential peers what our WMM / EDCA parameters are.

The goal seems fine but why bother building the WMM IE out of the actual
TX queue configuration? Shouldn't it normally be the other way around?
But I have no idea how QoS is supposed to work in a mesh...

johannes

