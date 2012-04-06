Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37391 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2DFWcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 18:32:16 -0400
Received: by dake40 with SMTP id e40so3160465dak.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 15:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204061751.13708.chunkeey@googlemail.com>
References: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com>
	<201204061322.26832.chunkeey@googlemail.com>
	<1333725089.5577.0.camel@jlt3.sipsolutions.net>
	<201204061751.13708.chunkeey@googlemail.com>
Date: Fri, 6 Apr 2012 15:32:16 -0700
Message-ID: <CAJ-VmokbRvPeag8tCcH2GBx7KwpWNHikVnzOwjiM2g=oUwZvPA@mail.gmail.com> (sfid-20120407_003219_578330_3899D52D)
Subject: Re: carl9170: not able to add P2P_GO - add_interface fail with -EBUSY
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Conceptually it'd be feasible to reset the hardware to a new state
that supports whatever the new vif features are.

That however includes all the gotcha! issues that occur when doing a
reset whilst live traffic is occuring..


Adrian
