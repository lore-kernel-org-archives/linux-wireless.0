Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:34705 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab2A3LIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:08:47 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 9A5B8DEC06
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:08:45 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id bJkIs3+XkNAs for <linux-wireless@vger.kernel.org>;
	Mon, 30 Jan 2012 11:40:41 +0000 (GMT)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 66F6ADEB65
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:08:45 +0000 (GMT)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/7] hostap: add DFS master ability
Date: Mon, 30 Jan 2012 11:08:43 +0000
References: <1327581689-22090-1-git-send-email-victorg@ti.com> <201201301035.19044.david.goodenough@btconnect.com> <CAGRGNgVhSdTNnmfw0=KHYEEz1r=5=uQbUNvPwTXODnS3LJmr=w@mail.gmail.com>
In-Reply-To: <CAGRGNgVhSdTNnmfw0=KHYEEz1r=5=uQbUNvPwTXODnS3LJmr=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201301108.43737.david.goodenough@btconnect.com> (sfid-20120130_120850_061557_3C6DB086)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 Jan 2012, Julian Calaby wrote:
> On Mon, Jan 30, 2012 at 21:35, David Goodenough
> 
> <david.goodenough@btconnect.com> wrote:
> > On Monday 30 Jan 2012, Goldenshtein, Victor wrote:
> >> On Thu, Jan 26, 2012 at 9:27 PM, David Goodenough
> >> 
> >> <david.goodenough@btconnect.com> wrote:
> >> > As I understand it hostapd is not involved in mesh (802.11s) networks,
> >> > so how does this integrate there?  As I understand it 802.11s is
> >> > entirely done in the kernel.
> >> 
> >> At this point we don't have any plans to extend DFS support to mesh
> >> networks.
> > 
> > That is fine, and obviously your choice.  My point is simply that
> > provision so that someone else can add it would be sensible, and in
> > particular to assume that anything that could have mesh support would
> > have a userland component kind of locks it out as I understand 802.11s
> > support at the moment.
> 
> I understand that using *secure* mesh requires a userspace component:
> 
> http://o11s.org/trac/wiki/HOWTO
> 
> Arguably there's no reason why a separate userspace component couldn't
> handle DFS for mesh interfaces. A project for the future could be to
> split it out of hostapd so it can be re-used for interfaces that
> aren't managed by hostapd.
> 
> Thanks,
True, I had not thought of that one.  So maybe it would be worth making
the DFS code in hostapd sufficiently modular that it can easily be moved/
copies/re-implemented into other environments.

David
