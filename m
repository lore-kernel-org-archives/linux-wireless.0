Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:20918 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYF1Syx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:54:53 -0400
Received: by an-out-0708.google.com with SMTP id d40so195140and.103
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:54:52 -0700 (PDT)
Message-ID: <43e72e890806281154j10c7032cpccfcd88469dfe187@mail.gmail.com> (sfid-20080628_205524_955042_3A74F309)
Date: Sat, 28 Jun 2008 11:54:52 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: compat-wireless high packet loss.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Cohen, Guy" <guy.cohen@intel.com>
In-Reply-To: <1ba2fa240806271746m15f967edj5693e2a6eecf15e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
	 <43e72e890806271300m626f67ayabf43fa02fe239b8@mail.gmail.com>
	 <1ba2fa240806271746m15f967edj5693e2a6eecf15e2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 5:46 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Fri, Jun 27, 2008 at 11:00 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Jun 26, 2008 at 4:03 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>>> We've experienced very high packet loss when using latest
>>> compat-wireless witth iwlwifi driver over 2.6.24 and 2.6.25 stable
>>> kernels. This is not happening with 2.6.26-rc3 as a target kernel (not
>>> sure about rc1 and rc2)
>>> The traffic is UDP TX with large tx buffers ~26000.
>>> We are still investigating yet if someone has any idea please share with us.
>>
>> I can't think of anything off the top of my head, really...
>
> This is something in the network stack. This is also happening with
> ethernet USB devices. Something between 2.6.25 and 2.6.26-rc3 has
> fixed it.
> Have to find what otherwise all the compat-wireless will be unusable for us
> Thanks for the answer anyway.

Either way if you try to port wireless-testing drivers to 2.6.25
you'll probably end up using the same things on compat-wirelesss or
just slightly modified, so if there is an issue regardless it can be
fixed through compat-wireless. Just my $0.02 Rupees.

  Luis
