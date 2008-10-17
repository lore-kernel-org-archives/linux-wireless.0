Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:65100 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYJQVP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 17:15:26 -0400
Received: by wf-out-1314.google.com with SMTP id 27so835783wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 14:15:25 -0700 (PDT)
Message-ID: <40f31dec0810171415t37e151fdy40841048e5400cf1@mail.gmail.com> (sfid-20081017_231530_203227_F2D94442)
Date: Sat, 18 Oct 2008 00:15:25 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: reduce checkpatch.pl errors
Cc: "John Daiker" <daikerjohn@gmail.com>, jirislaby@gmail.com,
	mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <b6c5339f0810171233v59e80b4bxce7bdb049e38a5f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48F8E470.8000103@gmail.com>
	 <b6c5339f0810171233v59e80b4bxce7bdb049e38a5f7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/17 Bob Copeland <me@bobcopeland.com>:
> On Fri, Oct 17, 2008 at 3:16 PM, John Daiker <daikerjohn@gmail.com> wrote:
>> A few changes to reduce checkpatch.pl errors in the ath5k driver.  For the
>> most part, I only fixed cosmetic things, and left the actual 'code flow'
>> untouched (hopefully)!
>>
>> Diff is against wireless-testing HEAD.
>>
>> Signed-off-by: John Daiker <daikerjohn@gmail.com>
>
> Please post patches inline if you can; they are easier to review that way.
>
> One easy way to convince yourself (and us) that there are no code changes
> is to compile with and without the patch and compare resulting binaries
> for no differences.
>
> All that said, I reviewed this one and it looks good...
>
> Reviewed-by: Bob Copeland <me@bobcopeland.com>
>
> --
> Bob Copeland %% www.bobcopeland.com
>

Same here...

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
