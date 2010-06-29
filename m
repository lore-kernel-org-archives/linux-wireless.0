Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48791 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0F2OAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 10:00:13 -0400
Date: Tue, 29 Jun 2010 09:49:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with firmware load on ipw2200
Message-ID: <20100629134930.GC5296@tuxdriver.com>
References: <4C29F711.1090306@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C29F711.1090306@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 29, 2010 at 08:37:21AM -0500, Larry Finger wrote:
> I'm trying to help an ipw2200 user on the openSUSE Wireless Forum and I'm
> stuck. The system is failing to load the firmware with error -2 (File or
> directory not found). The difficulty is that the required files are
> present with the correct permissions.
> 
> What system component might be missing and/or borked to get this symptom?

selinux?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
