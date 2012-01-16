Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35356 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab2APSsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:10 -0500
MIME-Version: 1.0
In-Reply-To: <1324933459-17242-1-git-send-email-asmadeus@codewreck.org>
References: <1324933459-17242-1-git-send-email-asmadeus@codewreck.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 16 Jan 2012 10:47:48 -0800
Message-ID: <CAB=NE6WAhddiUuf4yOfNAgqMF7GxM--ksDwEmvwdJdFYSjLGzA@mail.gmail.com> (sfid-20120116_195839_650615_90BAEED6)
Subject: Re: [PATCH] compat-wireless: build: Throw error if space in path
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 26, 2011 at 1:04 PM, Dominique Martinet
<asmadeus@codewreck.org> wrote:
> Because of make limitations, the build will fail if there are spaces in
> the path leading to the compat-wireless directory.
> I tried to make it work anyway for a while and, while it probably is
> possible, it would involve rewriting part of kbuild and well...
> This at least throws up nicely if there is a space in the path.
>

Thanks, you are missing your Signed-off-by tag and for compat-wireless
I use the same definition and practice of accepting patches only that
abide by that. The purpose of the SOB tag is defined on the
Documentation/SubmittingPatches file on the Linux kernel under the
Developer's Certificate of Origin 1.1. For your convenience I have
pasted here what it means:


        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.

  Luis
