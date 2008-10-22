Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58265 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbYJVS1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:27:25 -0400
Date: Wed, 22 Oct 2008 14:26:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] orinoco: reload firmware on resume
Message-ID: <20081022182636.GE15808@tuxdriver.com> (sfid-20081022_202730_533812_71889F2E)
References: <200810111816.26370.arvidjaar@mail.ru> <48F0E58F.6000900@gmail.com> <200810121636.34373.arvidjaar@mail.ru> <48F6450E.7040809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48F6450E.7040809@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 08:31:26PM +0100, Dave wrote:
> Andrey Borzenkov wrote:
>> On Saturday 11 October 2008, Dave wrote:
>>>> -	int err;
>>>> +	int err = 0;
>>
>> Fixed version attached.
>
> Acked-by: David Kilroy <kilroyd@googlemail.com>

Please repost this series with the finalized patches, rebased on the
current wireless-testing.  Also, please include the patches inline,
as your MIME encoding is confusing my tools.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
