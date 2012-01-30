Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:37330 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2A3KfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 05:35:24 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id C2BB9DEB67
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 10:35:21 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id 30Fr0DGhrQSX for <linux-wireless@vger.kernel.org>;
	Mon, 30 Jan 2012 11:07:17 +0000 (GMT)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 94256DEB62
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 10:35:21 +0000 (GMT)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/7] hostap: add DFS master ability
Date: Mon, 30 Jan 2012 10:35:18 +0000
References: <1327581689-22090-1-git-send-email-victorg@ti.com> <201201261927.17754.david.goodenough@btconnect.com> <CAK80WHZr484-9Ap2hxm1S59rBAh8z2hHOZ3c5w+cNLSakK_Cgg@mail.gmail.com>
In-Reply-To: <CAK80WHZr484-9Ap2hxm1S59rBAh8z2hHOZ3c5w+cNLSakK_Cgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201301035.19044.david.goodenough@btconnect.com> (sfid-20120130_113527_933465_C4D9C9C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 Jan 2012, Goldenshtein, Victor wrote:
> On Thu, Jan 26, 2012 at 9:27 PM, David Goodenough
> 
> <david.goodenough@btconnect.com> wrote:
> > As I understand it hostapd is not involved in mesh (802.11s) networks,
> > so how does this integrate there?  As I understand it 802.11s is entirely
> > done in the kernel.
> 
> At this point we don't have any plans to extend DFS support to mesh
> networks.
That is fine, and obviously your choice.  My point is simply that provision
so that someone else can add it would be sensible, and in particular to 
assume that anything that could have mesh support would have a userland
component kind of locks it out as I understand 802.11s support at the 
moment.

David
