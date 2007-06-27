Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbXF0VOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 17:14:43 -0400
Message-ID: <4682D323.2010605@redhat.com>
Date: Wed, 27 Jun 2007 23:14:11 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Subject: [PATCH 0/4] airo fixes
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

this is a series of four patches for the airo driver:

1/4: airo: don't use the interface name so much before registration
2/4: airo: delay parts of initialization until the netdev is up
3/4: airo: disable the PCI device when unloading module
4/4: airo: start with radio off

The first two fix the race condition Matteo Croce was experiencing.
The third one fixes a bug I noticed during testing.
The last one saves some power when the card is not used.

Michal
