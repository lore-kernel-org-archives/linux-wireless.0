Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:53030 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbZGPC1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 22:27:50 -0400
Received: from [192.168.10.7] (tosh.redfish-solutions.com [63.224.43.239])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.2/8.14.2) with ESMTP id n6G2RjKp002730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 20:27:49 -0600
Message-ID: <4A5E9021.3010000@redfish-solutions.com>
Date: Wed, 15 Jul 2009 19:27:45 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Can't cross-compile iw-0.9.15
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to add the "iw" package to astlinux (http://www.astlinux.org)
but it doesn't seem to be very cross-compilation friendly.

It wants to use pkg-config a lot, for instance...

Does anyone have a patched version that lets me pass in all my settings
brute force by hand?

Thanks,

-Philip


