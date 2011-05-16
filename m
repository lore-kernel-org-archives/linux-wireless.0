Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:55745 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab1EPNtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 09:49:06 -0400
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 47429DEC39
	for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 14:22:24 +0100 (BST)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id sC00EJCUiElJ for <linux-wireless@vger.kernel.org>;
	Mon, 16 May 2011 14:22:24 +0100 (BST)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 17EACDEC2E
	for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 14:22:24 +0100 (BST)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: Is the current link bitrate available in /proc or /sys?
Date: Mon, 16 May 2011 14:22:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201105161422.22323.david.goodenough@btconnect.com> (sfid-20110516_154910_246603_D21463C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I know I can get the bitrate using iwconfig or iw for a given wireless
card, but I was wondering if it was exposed anywhere in /proc or /sys.  
I looked but could not find it, which either means I looks in the wrong 
place or that it is not there.  If it is not there is a good reason why
not?  I ask because on my little embedded boards starting apps like iwconfig
or iw takes while, and I would rather get right to the data.

David
