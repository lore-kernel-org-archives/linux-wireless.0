Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:28421 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbXBWQzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:55:40 -0500
Received: by an-out-0708.google.com with SMTP id b33so407367ana
        for <linux-wireless@vger.kernel.org>; Fri, 23 Feb 2007 08:55:40 -0800 (PST)
Message-ID: <48f7fe350702230855n6b850331o110dff9bc9560b77@mail.gmail.com>
Date: Fri, 23 Feb 2007 11:55:39 -0500
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: d80211-2.0.1 build against 2.6.20-mm2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest version of d80211 does not build against the latest
mm-sources... Here is a patch to fix d80211 so that is DOES build
against 2.6.20-mm2:
http://www.rit.edu/~rmh3093/d80211-2.0.1-mm-fix.patch
