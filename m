Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab3EGNoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:44:04 -0400
Message-ID: <1367934240.8328.22.camel@jlt4.sipsolutions.net> (sfid-20130507_154411_203642_40B10317)
Subject: Re: [RFC 00/12] MBSS sharing across multiple interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 07 May 2013 15:44:00 +0200
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com> (sfid-20130503_043611_905025_22468B9A)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130503_043611_905025_22468B9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 19:33 -0700, Thomas Pedersen wrote:
> This patchset enables multiple interfaces on the same host to share mesh path
> selection and frame forwarding duties. The peering state machine remains
> per-interface.

Generally, this looks pretty good. The one thing I didn't see (maybe I
missed it) is how you handle different headroom/tailroom/crypto
requirements for different devices?

johannes

