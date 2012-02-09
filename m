Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34487 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2BINFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 08:05:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RvTgN-0006Oe-8y
	for linux-wireless@vger.kernel.org; Thu, 09 Feb 2012 14:05:03 +0100
Received: from 94.101.220.23 ([94.101.220.23])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:05:03 +0100
Received: from larsbro by 94.101.220.23 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 14:05:03 +0100
To: linux-wireless@vger.kernel.org
From: Lars Bro <larsbro@gmail.com>
Subject: mac80211 fixed rate packet injection
Date: Thu, 9 Feb 2012 12:38:35 +0000 (UTC)
Message-ID: <loom.20120209T131907-783@post.gmane.org> (sfid-20120209_140511_793306_D39ED615)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

At Jan 20, Sam Leffler posted a patch for enabeling packet injection with the
rate specified in the radiotap message. Did this ever make its way to the
release, or was it rejected.

I am investigating the feasibility of using such a function for train-wayside
communication where it is more important that all wayside radios that receive a
message forward it to the central. This use case does not comply with the
association-disassociation scheme, as this is one-to-one.

Lars Bro

