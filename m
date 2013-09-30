Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:51181 "EHLO
	homiemail-a86.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756115Ab3I3Tkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 15:40:51 -0400
Received: from homiemail-a86.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a86.g.dreamhost.com (Postfix) with ESMTP id 7776A360082
	for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 12:40:51 -0700 (PDT)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com [209.85.220.54])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: erik@erikelmore.com)
	by homiemail-a86.g.dreamhost.com (Postfix) with ESMTPSA id 59A4236007F
	for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 12:40:51 -0700 (PDT)
Received: by mail-pa0-f54.google.com with SMTP id kx10so6319428pab.41
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 12:40:50 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Sep 2013 15:40:50 -0400
Message-ID: <CA+=D8wmgsBimQhSYDqWbuzwM544YrX1Gj9gsmftQUHoD+QYeZw@mail.gmail.com> (sfid-20130930_214056_226699_398609EB)
Subject: Idea: wifi-over-ethernet (bear with me)
From: Erik Elmore <erik@erikelmore.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, linux-wireless.  I have an idea that I'd like to get some
feedback from you all.  I admit this idea is weird/flawed/broken and
seemingly useless, but I do have a practical application in mind, so
please hear me out.

Imagine two physical locations, site 1 and 2, that are well outside of
normal wifi range of each other.  Each site has a device that listens
for a subset of wifi frames and then sends them over a distribution
network to its counterpart at the other site.  Each device will also
re-transmit frames received via the distribution network.  Let's call
these devices listener1 and listener2.

Each site also contains one client device that wants to form an ad-hoc
network with the one in the other site.  Assuming that listener1 and
listener2 are configured to forward frames having a TA belonging to
the client device in their site, is it feasible for these devices to
form an ad-hoc network with the help of the listener devices?

I do have a proof-of-concept in the works.  It's not quite right yet,
but some things seem to work (sorta).

I welcome any comments, including those that call my sanity into question.

Thanks!

+=
Erik Elmore
