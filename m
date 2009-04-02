Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53647 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765257AbZDBQ3a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 12:29:30 -0400
Subject: Re: Read country code from EEPROM
From: reinette chatre <reinette.chatre@intel.com>
To: Mark Ryden <markryde@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <dac45060904020344i7cc1bbafh663d257d90018cb1@mail.gmail.com>
References: <dac45060904020344i7cc1bbafh663d257d90018cb1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 09:35:10 -0700
Message-Id: <1238690110.29969.27.camel@rc-desk> (sfid-20090402_182936_540171_886CF908)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Thu, 2009-04-02 at 03:44 -0700, Mark Ryden wrote:
> Hello,
>    I want to know what country code is written in the EEPROM  of an
> Intel iwlwifi wireless card. (It is 5100AGN).
> 
>  should I probe into the driver code and add some printk messages?
> or is there some util for it?

Not a specific country code, but you can find out the regulatory support
read from EEPROM when you load the driver with "debug50=0x1". With this
you will see, per channel, what is supported on the channels. This is
assuming that your driver is compiled with debug support.

Reinette

