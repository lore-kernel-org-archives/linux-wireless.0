Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1C1LkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:40:17 -0400
Received: by fxm17 with SMTP id 17so2552701fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:40:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Mon, 28 Mar 2011 13:38:26 +0200
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <201103251355.55824.helmut.schaa@googlemail.com> <1301058415.20631.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1301058415.20631.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281338.26627.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 25. März 2011 schrieb Johannes Berg:
> On Fri, 2011-03-25 at 13:55 +0100, Helmut Schaa wrote:
> 
> > So far the tx status as returned by the device look correct. I printed the
> > sequence numbers of failed AMPDU subframes and had a second device capturing
> > the traffic and compared them.

JFI, it seems indeed as if the tx status reporting in rt2800 is not 100%
accurate [1]. Not sure if this is really the culprit but it looks
feasible.

Helmut

[1]  http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003456.html
