Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1AYO5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 09:57:33 -0500
Subject: Re: [RFC] iwl3945: remove check_plcp_health
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
In-Reply-To: <20110125093507.GA6429@redhat.com>
References: <20110125093507.GA6429@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 06:56:03 -0800
Message-ID: <1295967363.31035.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 01:35 -0800, Stanislaw Gruszka wrote:
> This patch helps some users currently complaining about iwl3945
> performance.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=654599
> https://bugs.launchpad.net/ubuntu/maverick/+source/linux/+bug/621265/+index?comments=all
> 
> Patch does not helps all users, but they seems to be affected
> by different bug or bugs.
> 
> Patch effectively reverts commit a29576a7844326c5223f4d4adbfd3f4d64173d4c
> "iwl3945: add plcp error checking". It is minimal fix intended to
> -stable posting. I will post cleaning up patch, if fix will be accepted.
> 
> ---
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


Agree, maybe I am wrong, but I don't think this plcp checking never
being fully tested for 3945
  
Wey

