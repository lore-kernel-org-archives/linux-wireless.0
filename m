Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:14857 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030342AbXDKUEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 16:04:25 -0400
Message-ID: <461D3F48.70004@linux.intel.com>
Date: Wed, 11 Apr 2007 13:04:24 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkm@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and  association
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <200703311137.24379.flamingice@sourmilk.net> <20070411194059.GA2436@tuxdriver.com>
In-Reply-To: <20070411194059.GA2436@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Mar 31, 2007 at 11:37:19AM -0400, Michael Wu wrote:
>   
>> On Monday 26 March 2007 07:38, mohamed wrote:
>>     
>>> Add basic support for IEEE 802.11n discovery and association.
>>>
>>> This patch adds support to discover IEEE 802.11n AP and enable
>>> association to 802.11n Network. It parses beacon to discover 802.11n
>>> IE and include HT capability information element in Association Request
>>> Frame.
>>> It also call low level driver with the HT capability available during
>>> association.
>>>
>>>       
>> So.. what happens when the user is using a userspace mlme?
>>     
I am not familiar with userspace mlme what needed to be done?
Mohamed
>
> So...Michael is unhappy that I merged this one (and maybe unhappy
> about the whole series).
>
> Mohamed, could you address his concern that your patch preclude
> userland MLME functionality?  Let's make sure we aren't closing-off
> that capability.
>
> Thanks,
>
> John
>   
