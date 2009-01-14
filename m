Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397AbZANXzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 18:55:25 -0500
Subject: Re: 'N' Mode and 5GHz, Also WPA2
From: reinette chatre <reinette.chatre@intel.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200901141501.16207.Info@delphi-real-estate.com>
References: <200901131502.01047.Info@delphi-real-estate.com>
	 <200901140921.21823.Info@delphi-real-estate.com>
	 <1231972274.20912.142.camel@rc-desk>
	 <200901141501.16207.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 15:57:28 -0800
Message-Id: <1231977448.20912.146.camel@rc-desk> (sfid-20090115_005535_840771_45DEA37E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-14 at 15:01 -0800, Delphi Real Estate wrote:
> On Wednesday 14 January 2009 2:31:14 pm you wrote:
> > Could you please send some debug logs of the association attempts
> > (driver and wpa_supplicant) for us to look at? When you do, please
> > consider filing a bug at http://www.intellinuxwireless.org/bugzilla/ to
> > help us keep track of it.
> 
> I am not an expert, and the best way I know of evidencing the failure is
> 	ifdown wlan0 && ifconfig wlan0 down
> 	Kill any existing processes:  ps aux |grep wpa
> 	# wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0 -d
> 
> Is this the best way?

Please run wpa_supplicant with "-dd" for increased debugging. It may be
easier to do this manually. You can run "dmesg" to see the driver logs.
You can load the driver with "modprobe iwlagn debug=0x43fff" for
increased debugging.

Reinette


