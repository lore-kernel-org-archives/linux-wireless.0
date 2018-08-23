Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbeHWPyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:54:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Subject: Re: [PATCH 07/15] iwlwifi: add 80211 hdr offset to trace data
References: <20180821063657.30071-1-luca@coelho.fi>
        <20180821063657.30071-8-luca@coelho.fi>
        <877ekir5f2.fsf@kamboji.qca.qualcomm.com>
        <4d9dfd6108c4bdfab1811ac39d692f8e1272c134.camel@coelho.fi>
        <87mutdnxn4.fsf@kamboji.qca.qualcomm.com>
        <e95c118f8fb24b560809cd498417b399b28609d4.camel@coelho.fi>
Date: Thu, 23 Aug 2018 15:24:46 +0300
In-Reply-To: <e95c118f8fb24b560809cd498417b399b28609d4.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 23 Aug 2018 14:50:27 +0300")
Message-ID: <87lg8xmfsh.fsf@kamboji.qca.qualcomm.com> (sfid-20180823_142454_772917_269B2C44)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Thu, 2018-08-23 at 14:13 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > > > - * You should have received a copy of the GNU General Public
>> > > > License along with
>> > > > - * this program; if not, write to the Free Software
>> > > > Foundation,
>> > > > Inc.,
>> > > > - * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
>> > > > - *
>> > > >   * The full GNU General Public License is included in this
>> > > > distribution in the
>> > > >   * file called LICENSE.
>> > > >   *
>> > > 
>> > > Ok, you have more of these removals in this patch so I guess it's
>> > > intentional. But IMHO it would be nicer to remove these all in
>> > > one go
>> > > instead of sprinkle around in different patches.
>> > 
>> > IMHO it's too much fuzz for mostly useless warning removal... We
>> > need
>> > to update the copyright when this hits, so we just do it at the
>> > same
>> > time.
>> > 
>> > But you're the boss, I can submit a patch to remove just that, all
>> > at
>> > once.
>> 
>> Yeah, please do that. It shouldn't take more than few minutes anyway.
>> 
>> The thing is that then you are reviewing a big patchset and all of
>> sudden see a license text changes without no mention in the commit
>> log,
>> it takes extra time to check it. Sure, with one patch it doens't
>> matter
>> but then you are going through 20+ patches (or even more) it makes a
>> difference. So it's a lot easier for me to change all license text in
>> one go.
>
> Okay.  I'll send one patch on top of all these ones I sent already,
> okay?

Yeah, no need to change existing patches. So sounds good, thanks!

-- 
Kalle Valo
