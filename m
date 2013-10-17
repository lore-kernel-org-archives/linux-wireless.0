Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3JQO0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:26:47 -0400
Message-ID: <1382019990.14410.5.camel@jlt4.sipsolutions.net> (sfid-20131017_162655_433418_7B8A3058)
Subject: Re: [PATCH 0/5] rfkill-gpio: ACPI support
From: Johannes Berg <johannes@sipsolutions.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Rhyland Klein <rklein@nvidia.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Thu, 17 Oct 2013 16:26:30 +0200
In-Reply-To: <1381920823-15403-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1381920823-15403-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-16 at 13:53 +0300, Heikki Krogerus wrote:
> Hi,
> 
> The first patches prepare the driver for the support. The last patch
> can then add the support quite easily. With these patches, adding DT
> support later will be quite straight forward if someone needs it.

Applied. I'm totally relying on all the reviewers though, since I have
very little idea of what's going on. If anyone else wants to maintain
the rfkill-gpio driver I'd welcome that :-)

johannes

