Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:58936 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbYDASSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 14:18:09 -0400
Date: Tue, 1 Apr 2008 11:18:02 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080401111802.65fe259f@extreme> (sfid-20080401_191834_427734_996B9701)
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 1 Apr 2008 11:07:37 -0700
Inaky Perez-Gonzalez <inaky@linux.intel.com> wrote:

> 
> Intel would like to announce the initial release of a Linux WiMAX 
> common stack and drivers for its WiMAX devices (eg: Intel(r) 
> WiMAX/WiFi Link 5050, with estimated availability around third 
> quarter of 2008).
> 
> The project follows a standard layered approach: a generic WiMAX 
> kernel stack provides a common interface to control WiMAX devices. 
> A user space daemon and libraries provide a high level API for 
> control (network scanning, connection, disconnection, roaming 
> management, etc) and access to the drivers. 
> 
> Currently much of this higher level code is tailored to Intel's 
> device, but we wanted to get it out as soon as possible.
> 
> You can find the code and additional information at
> http://linuxwimax.org.
> 

Code review occurs on patch submittable not by pointing developers off
to an external project. Most likely there will be feedback that requires
changes to API and other choices so you want to do this soon.
