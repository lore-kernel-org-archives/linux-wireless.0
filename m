Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.224]:13357 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbXHBMsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:48:40 -0400
Received: by hu-out-0506.google.com with SMTP id 19so334659hue
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 05:48:39 -0700 (PDT)
Message-ID: <46B1D28F.1080006@gmail.com>
Date: Thu, 02 Aug 2007 14:48:15 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Winkler, Tomas" <tomas.winkler@intel.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com> <1186058047.24230.38.camel@johannes.berg>
In-Reply-To: <1186058047.24230.38.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-08-02 at 15:17 +0300, Winkler, Tomas wrote:
>
>   
>> There is a definitely a known issue in the driver that we still need to
>> resolve, but I agree with Johannes that there is a problem in design of
>> the configuration as well. 
>>     
>
> Nono, you cannot solve it in the driver. The whole design of mac80211
> mandates that assumption and I think it is a valid one to make.
why? did the old way (allow mode changing while up) caused any problems?

