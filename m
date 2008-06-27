Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:25468 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbYF0Rtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 13:49:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so156081nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 10:49:48 -0700 (PDT)
Message-ID: <f6ca9fed0806271049v37b4f7cetc9d918b877024a76@mail.gmail.com> (sfid-20080627_195003_494504_38B3984B)
Date: Fri, 27 Jun 2008 19:49:47 +0200
From: drago01 <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2008-06-27
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080627171524.GC20277@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080627153541.GA16597@tuxdriver.com>
	 <f6ca9fed0806270854u674a9d5aled463865e07829c8@mail.gmail.com>
	 <20080627171524.GC20277@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 7:15 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Jun 27, 2008 at 05:54:06PM +0200, drago01 wrote:
>> On Fri, Jun 27, 2008 at 5:35 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>
>> > Randy Dunlap (1):
>> >      iwlwifi: fix build for CONFIG_INPUT=n
>>
>> this one was NACKED by Ivo (well not exactly this but the 3945
>> version, and Yi posted an updated patch)
>
> That merged patch appears to be identical to the one in this thread:
>
>        http://marc.info/?l=linux-next&m=121436670630784&w=2
>
> That includes an ACK for Zhu Yi.  Am I missing something?

yeah this one: http://marc.info/?l=linux-wireless&m=121455866524106&w=2
