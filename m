Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:33694 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0BTPa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 10:30:27 -0500
Received: by gxk9 with SMTP id 9so1298473gxk.8
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2010 07:30:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266621325.25707.14.camel@mj>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
	 <20100219134448.GA2844@tuxdriver.com> <1266621325.25707.14.camel@mj>
Date: Sat, 20 Feb 2010 10:30:22 -0500
Message-ID: <b6c5339f1002200730t46298538k30930ed52255f06e@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make some
	functions static
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 6:15 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2010-02-19 at 08:44 -0500, John W. Linville wrote:
>> On Thu, Feb 18, 2010 at 08:28:02PM -0500, Pavel Roskin wrote:
>> Any reason not to just remove those functions instead of commenting
>> them out?
>
> I'm fine either way.  I tend to clean up more aggressively if I know
> that nobody will miss that code.  I wasn't sure in this case.

I don't think it will be a big deal if they disappear.  I think most of
them are just there because the original HAL had them.

Maybe one or two functions are waiting on an API in the stack to be useful
(e.g. antenna stuff), but we can always get these routines back from git
history if need be.

-- 
Bob Copeland %% www.bobcopeland.com
