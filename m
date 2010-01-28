Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54060 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0A1VO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 16:14:58 -0500
MIME-Version: 1.0
In-Reply-To: <4B61E530.1060008@redfish-solutions.com>
References: <43e72e891001221318p695f0923hea4f3573cedbd78d@mail.gmail.com>
	<4B61E530.1060008@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jan 2010 13:13:14 -0800
Message-ID: <43e72e891001281313g796316f9t4708f9fbc8853a10@mail.gmail.com>
Subject: Re: Hacking documentation updated for compat-wireless
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2010 at 11:27 AM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> On 01/22/2010 01:18 PM, Luis R. Rodriguez wrote:
>> I've updated the hacking documentation for compat-wireless, please let
>> me know if there are any questions:
>>
>> http://wireless.kernel.org/en/users/Download/hacking
>>
>>   Luis
>
> Hi Luis,
>
> Finally got around to reading this.  A couple of things weren't clear to me.
>
> On the page, if the $HOME is assumed to be /home/user, then:
>
> $HOME/wireless-testing is where the generated snapshot is left;
>
> the "git clone" of linux-next, compat, and compat-wireless-2.6 all happen directly in $HOME;
>
> Running this, however, doesn't work:
>
> [philipp@builder ~/cw]$ env | grep GIT
> GIT_TREE=/home/philipp/cw/wireless-testing

GIT_TREE should be your linux-next tree not wireless-testing tree.

  Luis
