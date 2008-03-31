Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:30496 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbYCaVYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:24:08 -0400
Received: by nf-out-0910.google.com with SMTP id g13so715338nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 14:24:07 -0700 (PDT)
To: TK <tobutaz+kernel@gmail.com>
Subject: Re: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Mon, 31 Mar 2008 23:23:51 +0200
Cc: linux-wireless@vger.kernel.org
References: <fsjfq1$vl8$1@ger.gmane.org> <fsou5a$biu$2@ger.gmane.org> <fsranu$qk3$1@ger.gmane.org>
In-Reply-To: <fsranu$qk3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803312323.51770.IvDoorn@gmail.com> (sfid-20080331_222413_123859_A9573D98)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 March 2008, TK wrote:
> On Sun, 30 Mar 2008 20:45:31 +0000, TK said:
> 
> > On Sun, 30 Mar 2008 20:26:44 +0000, TK said:
> > 
> >> On Fri, 28 Mar 2008 20:34:55 +0100, Ivo van Doorn said:
> >> 
> >>> The wireless-testing would be the most interesting since several race
> >>> conditions in the queues where fixed in there.
> 
> Great, I wasn't able to trigger the crash again.
> I expect there is no chance of a backport though - 2.6.25 doesn't play 
> nice with my distro, yet.

Sorry, but backporting isn't that easy.
rt2x00 has undergone some major changes after the 2.6.25 codebase,
some code was completely restructured and several new features were added.
Between the rt2x00 version in 2.6.25 and the latest wireless-testing code are
over 80 patches, those patches fixed a lot of issues, and backporting those is
troublesome due to the code restructuring (where the code restructuring itself
most likely fixed your bug).

Ivo
