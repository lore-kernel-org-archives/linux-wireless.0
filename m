Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXJHNr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 09:47:28 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l98DlRw3004052
	for <linux-wireless@vger.kernel.org>; Mon, 8 Oct 2007 09:47:27 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l98DlQwN008757
	for <linux-wireless@vger.kernel.org>; Mon, 8 Oct 2007 09:47:26 -0400
Received: from [10.13.248.82] (vpn-248-82.boston.redhat.com [10.13.248.82])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id l98DlPQN029367
	for <linux-wireless@vger.kernel.org>; Mon, 8 Oct 2007 09:47:25 -0400
Subject: rfkill framework status?
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 08 Oct 2007 09:49:09 -0400
Message-Id: <1191851349.2703.34.camel@localhost.localdomain> (sfid-20071008_144733_583709_4AC55C90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo;

I know there's a bunch of stuff queued for 2.6.24.  What's the general
status of the rfkill stuff, and are there any drivers using it already
besides b43 and rt2x00?  This is something I'd like to get HAL
supporting pretty quickly after 2.6.24 opens up if just to get a
jump-start on the situation.  Any pointers to userland interaction or
are people better off just reading the code?

Thanks,
Dan


