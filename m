Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbXJAHEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 03:04:41 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9174dOS016499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 1 Oct 2007 00:04:40 -0700
Received: from box (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id l9174dfd004160
	for <linux-wireless@vger.kernel.org>; Mon, 1 Oct 2007 00:04:39 -0700
Date: Mon, 1 Oct 2007 00:04:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: handle_ba_action
Message-Id: <20071001000439.1c9ae7b1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whoever added this to include/net/mac80211.h forgot to update
the ieee80211_ops comment block.
